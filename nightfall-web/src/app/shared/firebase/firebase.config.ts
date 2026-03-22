import { initializeApp } from 'firebase/app';
import { getDatabase } from 'firebase/database';

const firebaseConfig = {
  apiKey: 'AIzaSyDpJsUUOBSvTQF-jC4oAEGzPg8zPQlt0zM',
  authDomain: 'nighfall-project.firebaseapp.com',
  databaseURL: 'https://nighfall-project-default-rtdb.europe-west1.firebasedatabase.app',
  projectId: 'nighfall-project',
  storageBucket: 'nighfall-project.firebasestorage.app',
  messagingSenderId: '916401617246',
  appId: '1:916401617246:web:b95181fb4b52b101fff7cf',
};

const app = initializeApp(firebaseConfig);
export const db = getDatabase(app);
