import express from "express";
import { getCount, putCount } from "../controllers/count.controller";

const router = express.Router();

router.get("/", getCount);
router.put("/", putCount);

export default router;
