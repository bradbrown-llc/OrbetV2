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
                pop(staticcall(gas(), shr(0x60, mload(add(predictionHex, get_i))), add(predictionHex, add(0xB4, get_i)), mload(add(predictionHex, add(0x94, get_i))), add(predictionHex, mload(add(predictionHex, 0xC0))), mload(add(predictionHex, add(0x14, get_i)))))
                //staticcallRetToVarsLoop
                //retsCount == mload(+get_i+34)
                for { let j := 0 } lt(j, add(predictionHex, add(0x34, get_i))) { j := add(j, 1) } {
                    //need to get var_(i+varCount)Ptr and ret_iPtr and ret_iSize, then store ret_i into var_(i+varCount)
                }
            }
        }
    }
    
}