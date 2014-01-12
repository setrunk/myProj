#include "subqueuemodel.h"
#include "projectdata.h"

SubqueueModel::SubqueueModel(QObject *parent) :
    QAbstractListModel(parent)
{
}

int SubqueueModel::rowCount(const QModelIndex &parent) const
{
    return m_subqueue->files.count();
}

QVariant SubqueueModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() > m_subqueue->files.count())
        return QVariant();


    switch (role) {
    case NameRole:
        return m_subqueue->files[index.row()]->name;
        break;
    case Image1Role:
    case Image2Role:
    case Image3Role:
    {
        QString path = "C:/work/DQ_Hospital/player_2013_12_08/webserver/public";
        QString str = m_subqueue->files[index.row()]->thumbnail[role - Image1Role];
        if (str.startsWith('.'))
        {
            str.remove(0, 1);
            str = tr("file:///") + path + str;
        }
        return str;
    }
    }

    return QVariant();
}

QHash<int, QByteArray> SubqueueModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[Image1Role] = "image1";
    roles[Image2Role] = "image2";
    roles[Image3Role] = "image3";
    return roles;
}
