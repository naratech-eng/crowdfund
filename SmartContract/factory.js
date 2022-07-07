import web3 from "./web3";
import campaignFactory from "../SmartContract/build/campaignFactory.json";

const instance = new web3.eth.Contract(
  campaignFactory,
  '0x7d8d4f78f9aa56e9a3694eb4a1a35bf62f05d2e8'
);

export default instance;