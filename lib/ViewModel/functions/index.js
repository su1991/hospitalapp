const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotificationOnAppointment = functions.firestore
  .document("appointments/{appointmentId}")
  .onCreate(async (snap, context) =>
{

    const appointment = snap.data();

    const doctorId = appointment.doctorId;

    // 1️⃣ Get doctor data
const doctorDoc = await admin.firestore()
      .collection("User")
      .doc(doctorId)
      .get();

    if (!doctorDoc.exists) return;

    const doctorData = doctorDoc.data();
    const token = doctorData.fcmToken;

    if (!token) return;

    // 2️⃣ Create notification
const payload = {
  notification: {
    title: "New Appointment 📅",
    body: "A patient has booked an appointment with you",
  },
  token: token,
};

    // 3️⃣ Send notification
    await admin.messaging().send(payload);

    console.log("Notification sent!");
});