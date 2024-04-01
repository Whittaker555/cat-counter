import express from "express";
import count from "./count";

const router = express.Router();

router.use("/count", count);

export default router;
