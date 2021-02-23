// SPDX-License-Identifier: 0BSD

pragma solidity ^0.8.1;

contract Forutsi {
 
    /*function checkPrediction(bytes memory data) public view returns (bool) {
        
    }*/
    
    function getProcess(bytes memory data) public view returns (bytes memory) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x20)
            let PO := mload(add(data, 0x80))
            let PL := sub(mload(data), PO)
            mstore(add(ptr, 0x20), PL)
            let i := 0
            for {} lt(i, PL) { i:= add(i, 0x20) } {
                mstore(add(ptr, add(0x40, i)), mload(add(add(add(0x20, data), PO), i)))
            }
            return(ptr, add(add(PL, 0x60), i))
        }
    }
    
}