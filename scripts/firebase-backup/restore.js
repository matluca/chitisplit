const fs = require("fs");
const { initializeFirebaseApp, restore } = require('firestore-export-import')

const serviceAccount = require('./serviceAccountKey.json')

main();

async function main() {
    if(process.argv.length !== 3) {
        console.log(process.argv);
        throw new Error("This script takes the target file as its only argument");
    }
    const [_node, _script, file] = process.argv;

    initializeFirebaseApp(serviceAccount);

    const collections = JSON.parse(fs.readFileSync(file));
    await restore(collections, { autoParseDates: true, showLogs: true });
}
