#include "stagemodel.h"
#include "projectdata.h"

StageModel::StageModel(QObject *parent) :
    QAbstractListModel(parent), m_stage(0)
{
}

int StageModel::rowCount(const QModelIndex &parent) const
{
    return m_stage->children.count();
}

QVariant StageModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() > m_stage->children.count())
        return QVariant();

    if (role == Qt::DisplayRole)
    {
        return m_stage->children[index.row()]->desc;
    }

    return QVariant();
}

void StageModel::addItem(QString &str)
{
    Queue* queue = new Queue();
    queue->name = "queue";
    queue->desc = str;

    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_stage->children << queue;
    endInsertRows();
}

void StageModel::moveItem(int from, int to)
{
    Queue *queue = m_stage->children[from];
    removeItem(from);

    if (from < to)
        to -= 1;

    beginInsertRows(QModelIndex(), to, to);
    m_stage->children.insert(to, queue);
    endInsertRows();
}

void StageModel::removeItem(int i)
{
    if (i >= 0 && i < rowCount())
    {
        beginRemoveRows(QModelIndex(), i, i);
        m_stage->children.removeAt(i);
        endRemoveRows();
    }
}

void StageModel::renameItem(int i, QString &str)
{
    Queue *queue = m_stage->children[i];
    queue->desc = str;

    removeItem(i);

    beginInsertRows(QModelIndex(), i, i);
    m_stage->children.insert(i, queue);
    endInsertRows();
}
