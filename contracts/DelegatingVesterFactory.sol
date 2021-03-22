// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "./libraries/CloneLibrary.sol";


/// @author Alchemy Team
/// @title DelegatingVesterFactory
contract DelegatingVesterFactory {
    using CloneLibrary for address;

    event NewDelegateVester(address vester);
    address public immutable delegatingVesterImplementation;

    constructor(
        address _delegatingVesterImplementation
    ) {
        delegatingVesterImplementation = _delegatingVesterImplementation;
    }

    function DelegatingVesterMint(
        address alch_,
        address recipient_,
        uint256 vestingAmount_,
        uint256 vestingBegin_,
        uint256 vestingEnd_
    ) public returns (address vester) {
        vester = delegatingVesterImplementation.createClone();

        IDelegatingVester(vester).initialize(
            alch_,
            recipient_,
            vestingAmount_,
            vestingBegin_,
            vestingEnd_,
            address(this)
        );

        emit NewDelegateVester(vester);
    }
}


interface IDelegatingVester {
    function initialize(
        address alch_,
        address recipient_,
        uint256 vestingAmount_,
        uint256 vestingBegin_,
        uint256 vestingEnd_,
        address factoryContract
    ) external;
}