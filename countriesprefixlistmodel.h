#ifndef COUNTRIESPREFIXLISTMODEL_H
#define COUNTRIESPREFIXLISTMODEL_H

#include <QAbstractListModel>
#include <QFile>
#include <QDebug>
#include "countriesprefixitem.h"

class CountriesPrefixListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit CountriesPrefixListModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    enum RoleNames
    {
        FlagRole = Qt::UserRole,
        PrefixRole,
        CountryRole
    };

    virtual QHash<int, QByteArray> roleNames() const override;

    void addItemsFromCSV(QString path);

    Q_INVOKABLE QVariant checkPrefix(QString number);

private:
    QVector<CountriesPrefixItem> countriesList;
};

#endif // COUNTRIESPREFIXLISTMODEL_H
