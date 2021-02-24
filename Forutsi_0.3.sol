// SPDX-License-Identifier: 0BSD

pragma solidity ^0.8.1;

contract Forutsi {
 
    function checkPrediction(bytes memory predictionHex) public view {
        runGetsLoop(predictionHex);
    }
    
    function runGetsLoop(bytes memory predictionHex) public view {
        assembly {
            //varCount == mload(+0x60)
            let varCount := mload(add(predictionHex, 0x60))
            //getsLoop; get all external contract data required by prediction and store as vars
            for { let i := 0 } lt(i, mload(add(predictionHex, mload(add(predictionHex, 0x20))))) { i := add(i, 1) } {
                //run staticcall; gas(), a, in, inS, out, outS
                //a == shr(0xC, mload(+get_i)), get_i == mload(+getOffset+0x20+i*0x20), getOffset == mload(+0x20)
                let get_i := mload(add(predictionHex, add(0x20, add(mul(i, 0x20), mload(add(predictionHex, 0x20))))))
                //let to := shr(0x60, mload(add(predictionHex, get_i)))
                //inPtr == +get_i+0xB4
                //let inPtr := add(predictionHex, add(0xB4, get_i))
                //inSize == mload(+get_i+94)
                //let inSize := mload(add(predictionHex, add(0x94, get_i)))
                //out  == +mload(+scratchOffset), scratchOffset == mload(+0xC0)
                //let outPtr := add(predictionHex, mload(add(predictionHex, 0xC0)))
                //outSize == mload(+get_i+14)
                //let outSize := mload(add(predictionHex, add(0x14, get_i)))
                let scratchPtr := add(predictionHex, mload(add(predictionHex, 0xC0)))
                pop(staticcall(gas(), shr(0x60, mload(add(predictionHex, get_i))), add(predictionHex, add(0xB4, get_i)), mload(add(predictionHex, add(0x94, get_i))), scratchPtr, mload(add(predictionHex, add(0x14, get_i)))))
                //staticcallRetToVarsLoop
                //retsCount == mload(+get_i+34)
                for { let j := 0 } lt(j, mload(add(predictionHex, add(0x34, get_i)))) { j := add(j, 1) } {
                    //need to get var_(j+varCount)Ptr and ret_jPtr and ret_jSize, then store ret_j into var_(j+varCount)
                    //var_(j+varCount)Ptr == +varOffset_(j+varCount)+0x20,
                    //varOffset_(j+varCount) == mload(mul(j, 0x20)+mul(varCount, 0x20)++varsOffset+0x20), varsOffset == mload(+0x40)
                    let varsOffset := mload(add(predictionHex, 0x40))
                    let varOffset_jplusVarCount := mload(add(mul(j, 0x20), add(mul(varCount, 0x20), add(predictionHex, add(0x20, varsOffset)))))
                    let ret_jSize := mload(add(mul(j, 0x20), add(predictionHex, add(0x54, get_i))))
                    let ret_jPtr := scratchPtr
                    let var_jaddVarCountPtr := add(predictionHex, add(0x20, varOffset_jplusVarCount))
                    let test := add(var_jaddVarCountPtr, add(ret_jSize, ret_jPtr))
                    for { let k := 0 } lt(k, ret_jSize) { k := add(k, 0x20) } {
                        mstore(add(var_jaddVarCountPtr, k), mload(add(ret_jPtr, k)))
                    }
                    scratchPtr := add(scratchPtr, ret_jSize)
                }
            }
        }
    }
    
}