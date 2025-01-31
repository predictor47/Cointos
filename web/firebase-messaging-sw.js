importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-messaging.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;


firebase.initializeApp({
    apiKey: "AIzaSyDkLhv_IAfdS29p5lFVduZUGZHoXtSiyeE",
    authDomain: "coinverse-f947a.firebaseapp.com",
    databaseURL: 'https://oinverse-f947a.firebaseio.com',
    projectId: "coinverse-f947a",
    storageBucket: "coinverse-f947a.firebasestorage.app",
    messagingSenderId: "513615609284",
    appId: "1:513615609284:web:c0584c57379f22b284b891",
    measurementId: "G-PNEZ76J7SF"
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});