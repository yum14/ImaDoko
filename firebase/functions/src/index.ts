import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { firestore, messaging } from "firebase-admin";
import * as nodemailer from 'nodemailer';

admin.initializeApp();

const db = admin.firestore();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

// npm run build
// firebase emulators:start
// firebase deploy --only functions:[method]

interface Notification {
    id: string;
    from_id: string;
    title: string;
    body: string;
    to_ids: [string];
}

interface NotificationToken {
    id: string;
    notification_token: string;
}

export const sendNotification = functions.region('asia-northeast1').firestore.document('notifications/{id}').onCreate(async (snap, context) => {
    const triggerData = snap.data() as Notification;

    // デモ用データは削除しない
    if (triggerData.id === 'demo') {
        return;
    }

    try {
        const tokensSnapshot = await db.collection('notification_tokens').where(firestore.FieldPath.documentId(), 'in', triggerData.to_ids).get();

        var tokens: [string?] = [];

        tokensSnapshot.forEach(doc => {
            const token = doc.data() as NotificationToken;
            tokens.push(token.notification_token);
        });

        const deviceTokens: [string] = tokens.filter(Boolean) as [string]

        if (deviceTokens.length > 0) {

            const payload: messaging.MulticastMessage = {
                tokens: deviceTokens,
                notification: {
                　  title: triggerData.title,
                    body: triggerData.body,
                    // imageUrl: ''
                }
            };

            const response = await admin.messaging().sendMulticast(payload)
            // .sendToDevice(deviceTokens, payload);

            if (response.failureCount > 0) {
                functions.logger.error('Failure sending notification. messageid: ' + response.responses[0].messageId, response.responses[0].error);
            }

        } else {
            functions.logger.error('no notification token. from_id: ', triggerData.from_id);
        }

        // データ削除
        return snap.ref.delete().then(() => {
            functions.logger.info('success. from_id: ' + triggerData.from_id + ', to_ids: [' + triggerData.to_ids.join(',') + ']');
        })
        .catch(error => {
                  functions.logger.error('delete failed. from_id: ', triggerData.from_id);
                  functions.logger.error('error: ', error);
        });
    } catch (error) {
        functions.logger.error('from_id: ', triggerData.from_id, ', error: ', error);
    }
});

export const deleteExpiredData = functions.region('asia-northeast1').pubsub.schedule('0 2 1 * *').timeZone('Asia/Tokyo').onRun(async (context) => {
// export const removeExpiredData = functions.region('asia-northeast1').pubsub.schedule('*/5 * * * *').timeZone('Asia/Tokyo').onRun(async (context) => { //これはテスト用

    // 毎月1日2時にスケジュール実行
    try {

        // 削除対象年月は２日前
        const dt = new Date();
        dt.setDate(dt.getDate() - 2);

        const locationsSnap = await db.collection('locations').where('created_at', '<', dt).get();

        locationsSnap.forEach(doc => {
            doc.ref.delete().then(() => {
                // 何もしない
            }).catch((error) => {
                functions.logger.error('id: ', doc.id, ', error: ', error);
            });
        });

        const imadokoMessageSnap = await db.collection('imadoko_messages').where('created_at', '<', dt).get();

        imadokoMessageSnap.forEach(doc => {
            doc.ref.delete().then(() => {
                // 何もしない
            }).catch((error) => {
                functions.logger.error('id: ', doc.id, ', error: ', error);
            });
        });

        const kokodayoMessageSnap = await db.collection('kokodayo_messages').where('created_at', '<', dt).get();

        kokodayoMessageSnap.forEach(doc => {
            doc.ref.delete().then(() => {
                // 何もしない
            }).catch((error) => {
                functions.logger.error('id: ', doc.id, ', error: ', error);
            });
        });

        functions.logger.info("success. deleted data before ", dt.toString());

    } catch (error) {
        functions.logger.error('error: ', error);
    }
});

// 認証情報やメールアドレスはconfigに記載
// firebase functions:config:get

// gmailパスワードは以下のアプリパスワードで取得したものを設定（Googleアカウント→セキュリティ→アプリパスワード）
// https://myaccount.google.com/u/4/apppasswords?rapt=AEjHL4Nyyj6BDa8wPloKHONA04hFDvqO23xLbGR5VA_19LgDFp2h3o-NhEHtYodAzyHzGirG_qqoXK6yEtFpwH-3Fvh1mngL5Q
// 2022/5以降、「安全性の低いアプリ〜」の許可はできなくなった

const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;
const adminEmail = functions.config().admin.email;

// 送信に使用するメールサーバーの設定
let transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
      user: gmailEmail,
      pass: gmailPassword
  }
});

export const deleteNonExistentUser = functions.region('asia-northeast1').pubsub.schedule('0 4 1 * *').timeZone('Asia/Tokyo').onRun(async (context) => {
// export const deleteNonExistentUser = functions.region('asia-northeast1').pubsub.schedule('*/10 * * * *').timeZone('Asia/Tokyo').onRun(async (context) => { //これはテスト用

    // 毎月1日4時にスケジュール実行
    try {

        const dt = new Date();
        dt.setMonth(dt.getMonth() - 1)

        // 1月サインインされていないアカウントを対象とする
        const historySnap = await db.collection('sign_in_histories').where('last_sign_in_at', '<', dt).get();

        historySnap.forEach(doc => {

            admin.auth().getUser(doc.id).then((value: admin.auth.UserRecord) => {
                // 存在するユーザは処理を行わない
            }).catch(async (reason: any) => {
                
                // エラーの中でも該当ドキュメントが存在しない場合のみ処理続行
                if (String(reason).indexOf('Error: There is no user') !== 0) {
                    return;
                }

                try {
                    const batch = db.batch();
                    batch.delete(db.collection('profiles').doc(doc.id));
                    batch.delete(db.collection('avatar_images').doc(doc.id));
                    batch.delete(db.collection('notification_tokens').doc(doc.id));
                    batch.delete(db.collection('sign_in_histories').doc(doc.id));
                    await batch.commit();

                    functions.logger.info('アカウントデータ削除 uid: ', doc.id);
                    
                } catch (error) {
                    functions.logger.error('error: ', error);
                }

            })
        });
    } catch (error) {
        functions.logger.error('error: ', error);
    }
});


const createContent = (data: any) => {
  return `以下の内容でお問い合わせを受けました。
  
  お名前:
  ${data.name}
  
  メールアドレス:
  ${data.email}
  
  題名:
  ${data.title}

  本文:
  ${data.message}
  `;
};


exports.sendMail = functions.region('asia-northeast1').https.onCall(async (data, context) => {
  // メール設定
  let mailOptions = {
    from: gmailEmail,
    to: adminEmail,
    subject: "【Imadoko】お問い合わせ",
    text: createContent(data),
  };
  

  functions.logger.info(`from: ${mailOptions.from}, to: ${mailOptions.to}, subject: ${mailOptions.subject}, text: ${mailOptions.text}`);

  // 管理者へのメール送信
  try {
    transporter.sendMail(mailOptions, (err: Error | null, info: any) => {
      if (err) {
        functions.logger.warn(err.message);
      } else {
        functions.logger.info(`メール送信に成功`);
      }
    });
  } catch (e) {
    functions.logger.warn(`send failed. ${e}`);
    throw new functions.https.HttpsError('internal', 'send failed');
  }
});
