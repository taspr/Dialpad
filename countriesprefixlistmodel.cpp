#include "countriesprefixlistmodel.h"

CountriesPrefixListModel::CountriesPrefixListModel(QObject *parent)
    : QAbstractListModel(parent)
{
//    countriesList.append(CountriesPrefixItem(1, 1, "USA"));
//    countriesList.append(CountriesPrefixItem(2, 2, "asdf"));
//    countriesList.append(CountriesPrefixItem(3, 3, "asdf"));
//    countriesList.append(CountriesPrefixItem(4, 4, "UsdfgSA"));

    addItemsFromCSV(":/resources/countries/countries.txt");
}

int CountriesPrefixListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    Q_UNUSED(parent)

    return countriesList.count();
}

QVariant CountriesPrefixListModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();

    if (row < 0 || row > countriesList.count())
        return QVariant();

    switch (role)
    {
    case FlagRole:
        return QVariant(countriesList.at(row).getFlag());
    case PrefixRole:
        return QVariant(countriesList.at(row).getPrefix());
    case CountryRole:
        return QVariant(countriesList.at(row).getCountryName());
    }

    return QVariant();
}

QHash<int, QByteArray> CountriesPrefixListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FlagRole] = "flag";
    roles[PrefixRole] = "prefix";
    roles[CountryRole] = "countryName";

    return roles;
}

void CountriesPrefixListModel::addItemsFromCSV(QString path)
{
    QFile csvFile(path);

    if (!csvFile.exists())
    {
        qWarning() << "File not found";
        return;
    }

    if (!csvFile.open(QIODevice::ReadOnly))
    {
        qWarning() << csvFile.errorString();
        return;
    }

    while (!csvFile.atEnd())
    {
        QString line = csvFile.readLine();
        QStringList data = line.split(",");

        CountriesPrefixItem item(data[0].trimmed().toInt(), data[1].trimmed().toInt(), data[2].trimmed());

        countriesList.append(item);

        data.clear();
    }

    csvFile.close();
}

QVariant CountriesPrefixListModel::checkPrefix(QString number)
{
    int prefixNumber;

    if (number[0] == "+")
        prefixNumber = number.remove("+").toInt();
    else
        prefixNumber = number.toInt();

    while (prefixNumber != 0)
    {
        foreach(CountriesPrefixItem item, countriesList)
        {
            if (item.getPrefix() == prefixNumber)
                return QVariant(item.getFlag());
        }

        prefixNumber /= 10;
    }

    return QVariant();
}
