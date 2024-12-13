const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand } = require("@aws-sdk/lib-dynamodb");
exports.handler = async function (event) {
  const client = new DynamoDBClient({});
  const docClient = DynamoDBDocumentClient.from(client);
  const command = new PutCommand({
    TableName: process.env.CONNECTION_DYNAMODB_TABLE_NAME,
    Item: {
      connectionId: event.requestContext.connectionId,
    },
  });

  try {
    await docClient.send(command);
  } catch (err) {
    console.log(err);
    return {
      statusCode: 500,
    };
  }
  return {
    statusCode: 200,
  };
};
