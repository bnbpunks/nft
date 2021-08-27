pragma solidity ^0.8.0;

library ConvertLib{
	function public convert(uint amount,uint conversionRate) returns (uint convertedAmount)
	{
		return amount * conversionRate;
	}
}
