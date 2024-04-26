import { Request, Response, NextFunction, query } from "express";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, QueryCommand, UpdateCommand } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({ region: "eu-west-2" });
const docClient = DynamoDBDocumentClient.from(client);
const personName = "catherine";
const counterName = "love";
export const putCount = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const updateCommand = new UpdateCommand({
    TableName: "counter",
    Key: {
      counterName: counterName,
      person: personName
    },
    UpdateExpression: "SET totalClicks = :totalClicks",
    ExpressionAttributeValues: {
      ":totalClicks": req.body.count,
    },
    ReturnValues: "ALL_NEW",
  });
  let response = await docClient.send(updateCommand);
  res.status(200).json(response.Attributes?.totalClicks);
};

export const getCount = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const queryCommand = new QueryCommand({
    TableName: "counter",
    KeyConditionExpression: "counterName = :counterName AND person = :person",
    ExpressionAttributeValues: {
      ":counterName": counterName,
      ":person": personName,
    },
    ProjectionExpression: "totalClicks",
  });
  let response = await docClient.send(queryCommand);
  console.log(response)
  var count = response.Items?.[0]?.totalClicks ?? 0;
  res.status(200).json(count);
};
