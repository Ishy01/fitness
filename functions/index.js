/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.generateRecommendations = functions.firestore
  .document("users/{userId}/daily_progress/{progressId}")
  .onWrite(async (change, context) => {
    const userId = context.params.userId;
    const progressData = change.after.exists ? change.after.data() : null;
    const yesterdayDoc = await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .collection("daily_progress")
      .orderBy("timestamp", "desc")
      .limit(2)
      .get();

    if (progressData && yesterdayDoc.size === 2) {
      const yesterdayData = yesterdayDoc.docs[1].data();
      const recommendations = [];

      // Steps recommendation logic
      if (yesterdayData.steps < 5000 && progressData.steps < 5000) {
        recommendations.push("You've had two days with less than 5,000 steps. Let's aim higher today!");
      }

      // Calories recommendation logic
      if (progressData.calories < 200) {
        recommendations.push("Consider a workout to burn more calories.");
      }

      // Distance recommendation logic (Example)
      if (progressData.distance < 2) {
        recommendations.push("Try to cover at least 2 km today to improve your endurance.");
      }

      if (recommendations.length === 0) {
        recommendations.push("Great job! Keep up the good work!");
      }

      await admin
        .firestore()
        .collection("users")
        .doc(userId)
        .collection("recommendations")
        .add({
          recommendations: recommendations,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });

      const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(userId)
        .get();
      const userToken = userDoc.data().fcmToken;

      if (userToken) {
        await admin.messaging().send({
          token: userToken,
          notification: {
            title: "New Recommendation",
            body: recommendations.join("\n"),
          },
        });
      }
    }

    return null;
  });
