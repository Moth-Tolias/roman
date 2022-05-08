import std.stdio;

void main() @safe
{
	immutable numerals = "IVXLCDMQRYTUO";

	for(int i; i < numerals.length; i += 2)
	{
		import std.algorithm;
		auto place = numerals[i .. min(i + 3, numerals.length)];

		assert(place.length >= 1);
		assert(place.length <= 3);

		immutable formats = romanFormatsByParams(place.length);
		place.length = 3;

		foreach(format; formats)
		{
			writefln(format, place[0], place[1], place[2]);
		}
	}
}

immutable canonicalRomanDigits = "IVXLCDM";
immutable canonicalRomanFormats = romanFormats_();

auto romanFormats_() @nogc nothrow pure @safe
{
	string[10] formats;

	formats[0] = "";
	formats[1] = "%1$s";
	formats[2] = "%1$s%1$s";
	formats[3] = "%1$s%1$s%1$s";
	formats[4] = "%1$s%2$s";
	formats[5] = "%2$s";
	formats[6] = "%2$s%1$s";
	formats[7] = "%2$s%1$s%1$s";
	formats[8] = "%2$s%1$s%1$s%1$s";
	formats[9] = "%1$s%3$s";

	return formats;
}

immutable (string[]) romanFormatsByParams(in size_t params, const ref string[10] formats = canonicalRomanFormats) @nogc nothrow pure @safe
in(0 <= params)
in(params <= 3)
{
	switch(params)
	{
		case 0: return formats[0 .. 1];
		case 1: return formats[0 .. 4];
		case 2: return formats[0 .. 9];
		case 3: return formats;
		default: assert(false, "this will never happen.");
	}
}

auto maxInRoman(in size_t digits = canonicalRomanDigits.length)
{
	if (digits == 0)
	{
		return 0;
	}

	if (digits % 2 == 0)
	{
		return (4 * (1 + (digits / 10)) ) - 1;
	}

	return (9 * (1 + (digits / 10)) ) - 1;
}

@nogc nothrow pure @safe unittest
{
	assert(maxInRoman(0) == 0);
	assert(maxInRoman(1) == 3);
	assert(maxInRoman(2) == 8);
	assert(maxInRoman(3) == 39);
	assert(maxInRoman(4) == 89);
	assert(maxInRoman(5) == 399);
	assert(maxInRoman(6) == 899);
	assert(maxInRoman(7) == 3999);
}

//todo: unicode support
auto valueOfRomanDigit(in char digit, in string digits = canonicalRomanDigits) @nogc nothrow pure @safe
in (digit.among(digits))
{
	//
}

auto valueOfRomanDigit(in size_t digitNo) @nogc nothrow pure @safe
in (digitNo > 0)
{
	immutable bool isEven = (digitNo % 2 == 0 ? true : false);
	if (isEven)
	{
		return 5 * (10 * (digitNo / 2));
	}
	else
	{
		return (10 * (digitNo / 2));
	}
}

@nogc nothrow pure @safe unittest
{
	assert(valueOfRomanDigit(1) == 1);
	assert(valueOfRomanDigit(2) == 5);
	assert(valueOfRomanDigit(3) == 10);
	assert(valueOfRomanDigit(4) == 50);
	assert(valueOfRomanDigit(5) == 100);
	assert(valueOfRomanDigit(6) == 500);
	assert(valueOfRomanDigit(7) == 1000);
}

auto toRoman(in size_t value, in string digits = canonicalRomanDigits) nothrow pure @safe
{
	foreach(i; 0 .. noOfDigits(value))
	{
		//
	}
}

auto noOfDigits(T)(in T value, in size_t base = 10) @nogc
        if (isIntegral!T)
{
	if (digits == 0)
	{
		return 0;
	}

    return ceil(log(value) / log(base));
}

@nogc nothrow pure @safe unittest
{
    assert(noOfDigits(1234) == 4);
}

auto nthDigit(T)(in T value, in ptrdiff_t n, in size_t base = 10) @nogc nothrow pure @safe
	if (isIntegral!T)
in(value >= 0)
in
{
	auto adjust = n >= 0 ? n : abs(n) - 1;
    assert(adjust < noOfDigits(value, base));
}
do
{
    auto adjust = n >= 0 ? noOfDigits(value, base) - (n + 1) : abs(n) - 1;
    return floor(value / pow(base, adjust)) % base;
}

@nogc nothrow pure @safe unittest
{
    assert(1234.nthDigit(0) == 1);
    assert(1234.nthDigit(1) == 2);
    assert(1234.nthDigit(2) == 3);
    assert(1234.nthDigit(3) == 4);
    assert(1234.nthDigit(-1) == 4);
    assert(1234.nthDigit(-2) == 3);
    assert(1234.nthDigit(-3) == 2);
    assert(1234.nthDigit(-4) == 1);
}
