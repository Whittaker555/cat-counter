import express from "express";
import morgan from "morgan";
import routes from "./routes";
const serverless = require("serverless-http");

const app = express();
const router = express.Router();

router.use(morgan("dev"));
router.use(express.urlencoded({ extended: false }));
router.use(express.json());

router.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization",
  );
  if (req.method === "OPTIONS") {
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE");
    return res.status(200).json({});
  }
  next();
});

router.use("/", routes);

router.use((req, res, next) => {
  const error: any = new Error("Not Found");
  error.status = 404;
  return res.status(404).json({
    message: error.message,
  });
});

app.use(router);

// const PORT = process.env.PORT || 3000;
// app.listen(PORT, () => {
//   console.log(`Api is running in http://localhost:${PORT}`);
// });
module.exports.handler = serverless(app);
