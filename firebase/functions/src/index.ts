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

    db.collection('imakoko_notifications').doc(request.query.id as string).set({
        id: request.query.id as string,
        latitude: 1.1234,
        longitude: 5.1234,
        owner_id: 'SdJQbPCU0ZPwqZjnXUJ5aHm4CMa2',
        owner_name: 'test',
        to: ['SdJQbPCU0ZPwqZjnXUJ5aHm4CMa2']
    })
    .then(() => {
        response.send('success!');
    })
    .catch((error) => {
        response.send(error);
    });
});

export const sendImakokoNotification = functions.region('asia-northeast1').firestore.document('imakoko_notifications/{id}')
    .onCreate(async (snap, context) => {
        const triggerData = snap.data() as ImakokoNotification;
        functions.logger.info("imakoko_notification: ", triggerData.id);

        try {
            const tokensSnapshot = await db.collection('notification_tokens').where(firestore.FieldPath.documentId(), 'in', triggerData.to).get();

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
                        title: 'イマココ',
                        body: triggerData.owner_name + "さんからのイマココ",
                        // imageUrl: ''
                    },
                    data: {
                        owner_id: triggerData.owner_id,
                        latitude: triggerData.latitude.toString(),
                        longitude: triggerData.longitude.toString(),  
                    }
                };

                const response = await admin.messaging().sendMulticast(payload)
                // .sendToDevice(deviceTokens, payload);

                if (response.failureCount > 0) {
                    functions.logger.error('Failure sending notification. messageid: ' + response.responses[0].messageId, response.responses[0].error);
                }

            } else {
                functions.logger.error('no notification token. owner_id: ', triggerData.owner_id);
            }

            // データ削除
            return snap.ref.delete()
                .catch(error => {
                    functions.logger.error('delete failed. owner_id: ', triggerData.owner_id);
                    functions.logger.error('error: ', error);
                });

        } catch (error) {
            functions.logger.error('error: ', error);
            functions.logger.error('owner_id: ', triggerData.owner_id);
        }
    });

interface ImakokoNotification {
    id: string;
    owner_id: string;
    owner_name: string;
    latitude: number;
    longitude: number;
    to: [string];
}

interface NotificationToken {
    id: string;
    notification_token: string;
}
