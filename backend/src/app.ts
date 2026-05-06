import main from "./routes/main";
import ownerRouter from "./routes/owner.route";

const app = () => {
  main();
  
  console.log("app.ts");
};

app();
