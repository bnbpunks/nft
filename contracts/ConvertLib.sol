pragma solidity ^0.6.0;

library ConvertLib{
	function convert(uint amount,uint conversionRate) returns (uint convertedAmount)
	{
		return amount * conversionRate;
	}
}
