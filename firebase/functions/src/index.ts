import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { firestore, messaging } from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

// npm run build
// firebase emulators:start
// firebase deploy --only functions:[method]


// export const helloWorld = functions.region('asia-northeast1').https.onRequest((request, response) => {
//     functions.logger.info("Hello logs!", {structuredData: true});
//     response.send("Hello from Firebase!");
// });

export const createTestData = functions.region('asia-northeast1').https.onRequest((request, response) => {

    db.collection('notifications').doc(request.query.id as string).set({
        id: request.query.id as string,
        from_id: 'SdJQbPCU0ZPwqZjnXUJ5aHm4CMa2',
        title: 'test title',
        body: 'test body',
        to_ids: ['SdJQbPCU0ZPwqZjnXUJ5aHm4CMa2']
    })
    .then(() => {
        response.send('success!');
    })
    .catch((error) => {
        response.send(error);
    });
});

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

export const removeExpiredData = functions.region('asia-northeast1').pubsub.schedule('0 2 1 * *').timeZone('Asia/Tokyo').onRun(async (context) => {
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
