pragma solidity ^0.8.0;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function public Migrations() {
    owner = msg.sender;
  }

  function public setCompleted(uint completed) restricted {
    last_completed_migration = completed;
  }

  function public upgrade(address new_address) restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
