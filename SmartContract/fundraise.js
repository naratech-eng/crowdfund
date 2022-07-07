import web3 from "./web3";
import FundRaise from "./build/FundRaise.json";

const campaign = (address) => {
  return new web3.eth.Contract(FundRaise, address);
};
export default campaign;