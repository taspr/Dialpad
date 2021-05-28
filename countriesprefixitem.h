#ifndef COUNTRIESPREFIXITEM_H
#define COUNTRIESPREFIXITEM_H

#include <QObject>

class CountriesPrefixItem
{
public:
    CountriesPrefixItem(int flag = 0, int prefix = 0, QString countryName = "");

    int getFlag() const;
    void setFlag(int value);

    int getPrefix() const;
    void setPrefix(int value);

    QString getCountryName() const;
    void setCountryName(const QString &value);

private:
    int flag;
    int prefix;
    QString countryName;
};

#endif // COUNTRIESPREFIXITEM_H
