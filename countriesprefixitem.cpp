#include "countriesprefixitem.h"


CountriesPrefixItem::CountriesPrefixItem(int flag, int prefix, QString countryName)
{
    this->flag = flag;
    this->prefix = prefix;
    this->countryName = countryName;
}

int CountriesPrefixItem::getFlag() const
{
    return flag;
}

void CountriesPrefixItem::setFlag(int value)
{
    flag = value;
}

int CountriesPrefixItem::getPrefix() const
{
    return prefix;
}

void CountriesPrefixItem::setPrefix(int value)
{
    prefix = value;
}

QString CountriesPrefixItem::getCountryName() const
{
    return countryName;
}

void CountriesPrefixItem::setCountryName(const QString &value)
{
    countryName = value;
}
