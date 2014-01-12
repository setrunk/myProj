#include "queuemodel.h"
#include "projectdata.h"

QueueModel::QueueModel(QObject *parent) :
    QAbstractListModel(parent), m_queue(0)
{
}

int QueueModel::rowCount(const QModelIndex &parent) const
{
    return m_queue->children.count();
}

QVariant QueueModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() > m_queue->children.count())
        return QVariant();

    if (role == Qt::DisplayRole)
    {
        return m_queue->children[index.row()]->desc;
    }

    return QVariant();
}

void QueueModel::addItem(QString &str)
{
    Subqueue* subqueue = new Subqueue();
    subqueue->name = "subqueue";
    subqueue->desc = str;

    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_queue->children << subqueue;
    endInsertRows();
}

void QueueModel::removeItem(int i)
{
    if (i >= 0 && i < rowCount())
    {
        beginRemoveRows(QModelIndex(), i, i);
        m_queue->children.removeAt(i);
        endRemoveRows();
    }
}

void QueueModel::renameItem(int i, QString &str)
{
    Subqueue *subqueue = m_queue->children[i];
    subqueue->desc = str;

    removeItem(i);

    beginInsertRows(QModelIndex(), i, i);
    m_queue->children.insert(i, subqueue);
    endInsertRows();
}
