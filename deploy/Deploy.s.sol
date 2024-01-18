// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { console } from "forge-std/console.sol";
import { Script } from "forge-std/Script.sol";

// import { Proxy } from "@eth-optimism-bedrock/contracts/universal/Proxy.sol";
// import { BalanceTracker } from "@base-contracts/src/revenue-share/BalanceTracker.sol";
import "../contracts/samples/TokenPaymaster.sol";
import "../contracts/samples/utils/OracleHelper.sol";
import "../contracts/samples/utils/UniswapHelper.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "../contracts/interfaces/IEntryPoint.sol";

contract DeployTokenPaymaster is Script {
   address payable[] systemAddresses;
   uint256[] targetBalances;

   function run() external {
        address deployer = vm.envAddress("TOKEN_PAYMASTER_DEPLOYER");
        // address payable profitWallet = payable(vm.envAddress("PROFIT_WALLET"));
        // address payable outputProposer = payable(vm.envAddress("OUTPUT_PROPOSER"));
        // address payable batchSender = payable(vm.envAddress("BATCH_SENDER"));
        // uint256 outputProposerTargetBalance = vm.envUint("OUTPUT_PROPOSER_TARGET_BALANCE");
        // uint256 batchSenderTargetBalance = vm.envUint("BATCH_SENDER_TARGET_BALANCE");
        // address admin = vm.envAddress("BALANCE_TRACKER_ADMIN");
        // string memory salt = vm.envString("BALANCE_TRACKER_SALT");

        // console.log("Deployer: %s", deployer);
        // console.log("Profit Wallet: %s", profitWallet);
        // console.log("Batch Sender: %s", batchSender);
        // console.log("Output Proposer: %s", outputProposer);
        // console.log("Batch Sender Target Balance: %s", batchSenderTargetBalance);
        // console.log("Output Proposer Target Balance: %s", outputProposerTargetBalance);
        // console.log("Admin: %s", admin);
        // console.log("Salt: %s", salt);

        vm.broadcast(deployer);
        TokenPaymaster tokenPaymasterImpl = new TokenPaymaster(
            IERC20Metadata("0xf175520c52418dfe19c8098071a252da48cd1c19"), // Base Goerli USDC address
            IEntryPoint("0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789"),
            IERC20("0x4200000000000000000000000000000000000006"),
            ISwapRouter("0xD753a89450213A8D7f7aCCE3a615d71ebD97366d"),
            TokenPaymaster.TokenPaymasterConfig({
                priceMarkup: 10000,
                minEntryPointBalance: 1000000000000000000,
                refundPostopCost: 21000,
                priceMaxAge: 300
            }),
            OracleHelper.OracleHelperConfig({
                cacheTimeToLive: 300,
                tokenOracle: IOracle("0xb85765935B4d9Ab6f841c9a00690Da5F34368bc0"),
                nativeOracle: IOracle("0xcD2A119bD1F7DF95d706DE6F2057fDD45A0503E2"),
                tokenToNativeOracle: false,
                tokenOracleReverse: true,
                nativeOracleReverse: true,
                priceUpdateThreshold: 20000
            }),
            UniswapHelper.UniswapHelperConfig({
                minSwapAmount: 1000000000,
                uniswapPoolFee: 3000,
                slippage: 1000
            }),
            deployer
        );
   }
}