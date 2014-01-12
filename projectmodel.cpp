#include "projectmodel.h"
#include "projectdata.h"

ProjectModel::ProjectModel(QObject *parent) :
    QAbstractListModel(parent), m_project(0)
{
}

int ProjectModel::rowCount(const QModelIndex &parent) const
{
    return m_project->children.count();
}

QVariant ProjectModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() > m_project->children.count())
        return QVariant();

    if (role == Qt::DisplayRole)
    {
        return m_project->children[index.row()]->desc;
    }

    return QVariant();
}

void ProjectModel::addItem(QString &str)
{
    Stage* stage = new Stage();
    stage->name = "stage";
    stage->desc = str;

    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_project->children << stage;
    endInsertRows();
}

void ProjectModel::removeItem(int i)
{
    if (i >= 0 && i < rowCount())
    {
        beginRemoveRows(QModelIndex(), i, i);
        m_project->children.removeAt(i);
        endRemoveRows();
    }
}

void ProjectModel::renameItem(int i, QString &str)
{
    Stage *stage = m_project->children[i];
    stage->desc = str;

    removeItem(i);

    beginInsertRows(QModelIndex(), i, i);
    m_project->children.insert(i, stage);
    endInsertRows();
}
