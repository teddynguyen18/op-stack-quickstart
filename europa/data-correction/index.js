const fs = require('fs');
const path = require('path');

const ACTION_TIMER = 'CORRECT_DATA';

console.time(ACTION_TIMER);

const { DEPLOYMENTS_PATH, DEPLOYMENT_CONTEXT } = process.env;
const FILE_NAME_TO_CORRECT = 'L1CrossDomainMessengerProxy.json';
const FILE_PATH_TO_CORRECT = path.resolve(DEPLOYMENTS_PATH, DEPLOYMENT_CONTEXT, FILE_NAME_TO_CORRECT);

const dataToCorrect = require(FILE_PATH_TO_CORRECT);

console.log('Before Correction', dataToCorrect.args);
if (typeof dataToCorrect.args === 'string') {
  dataToCorrect.args = JSON.parse(dataToCorrect.args.replace(/\\/g, ''));
  fs.writeFileSync(FILE_PATH_TO_CORRECT, JSON.stringify(dataToCorrect, null, 2), 'utf8');
  console.log('After Correction', dataToCorrect.args);
}

console.timeEnd(ACTION_TIMER);
