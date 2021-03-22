// SP-License-Identifier: MIT
pragma solidity ^0.6.0;
import "@openzeppelin/contracts/math/SafeMath.sol";


/// @author Alchemy Team
/// @title DelegatingVester
contract DelegatingVester {
  /// @dev The name of this contract
  string public constant name = "Alchemy Delegating Vesting Contract";

  using SafeMath for uint256;

  address public alch;

  uint256 public vestingAmount;
  uint256 public vestingBegin;
  uint256 public vestingEnd;

  address public recipient;
  uint256 public lastUpdate;

  // factory contract address
  address public _factoryContract;

  constructor() public {
    // Don't allow implementation to be initialized.
    _factoryContract = address(1);
  }

  function initialize(
    address alch_,
    address recipient_,
    uint256 vestingAmount_,
    uint256 vestingBegin_,
    uint256 vestingEnd_,
    address factoryContract
  ) external
  {
    require(_factoryContract == address(0), "already initialized");
    require(factoryContract != address(0), "factory can not be null");

    require(
      vestingBegin_ >= block.timestamp,
      "DelegatingVester::constructor: vesting begin too early"
    );
    require(
      vestingEnd_ > vestingBegin_,
      "DelegatingVester::constructor: vesting end too early"
    );

    alch = alch_;
    recipient = recipient_;
    _factoryContract = factoryContract;

    vestingAmount = vestingAmount_;
    vestingBegin = vestingBegin_;
    vestingEnd = vestingEnd_;

    lastUpdate = vestingBegin_;
  }

  function delegate(address delegatee) external {
    require(
      msg.sender == recipient,
      "DelegatingVester::delegate: unauthorized"
    );
    IAlch(alch).delegate(delegatee);
  }

  function setRecipient(address recipient_) external {
    require(
      msg.sender == recipient,
      "DelegatingVester::setRecipient: unauthorized"
    );
    recipient = recipient_;
  }

  function claim() public {
    uint256 amount;
    if (block.timestamp >= vestingEnd) {
      amount = IAlch(alch).balanceOf(address(this));
    } else {
      amount = vestingAmount.mul(block.timestamp - lastUpdate).div(
        vestingEnd - vestingBegin
      );
      lastUpdate = block.timestamp;
    }
    IAlch(alch).transfer(recipient, amount);
  }

  fallback() external payable {
    claim();
  }

  receive() external payable {
    claim();
  }
}

interface IAlch {
  function balanceOf(address account) external view returns (uint256);
  function transfer(address dst, uint256 rawAmount) external returns (bool);
  function delegate(address delegatee) external;
}