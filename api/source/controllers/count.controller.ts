import { Request, Response, NextFunction } from "express";

let count = 555;

export const putCount = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  count = req.body.count;
  getCount(req, res, next);
};

export const getCount = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  return res.send(count.toString());
};
