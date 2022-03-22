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

export const sendNotification = functions.region('asia-northeast1').firestore.document('notifications/{id}')
    .onCreate(async (snap, context) => {
        const triggerData = snap.data() as Notification;

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
            return snap.ref.delete()
                .then(() => {
                    functions.logger.info('success. from_id: ' + triggerData.from_id + ', to_ids: [' + triggerData.to_ids.join(',') + ']');
                })
                .catch(error => {
                    functions.logger.error('delete failed. from_id: ', triggerData.from_id);
                    functions.logger.error('error: ', error);
                });

        } catch (error) {
            functions.logger.error('error: ', error);
            functions.logger.error('from_id: ', triggerData.from_id);
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
