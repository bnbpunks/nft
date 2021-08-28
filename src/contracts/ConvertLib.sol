pragma solidity ^0.8.0;

library ConvertLib{
	public function convert(uint amount,uint conversionRate) returns (uint convertedAmount)
	public {
		return amount * conversionRate;
	}
}
