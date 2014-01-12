#include "projectlistmodel.h"
#include "projectdata.h"

ProjectListModel::ProjectListModel(QObject *parent) :
    QAbstractListModel(parent)
{
}

ProjectListModel::~ProjectListModel()
{
}

int ProjectListModel::rowCount(const QModelIndex &parent) const
{
    return m_projectList->children.count();
}

QVariant ProjectListModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() > m_projectList->children.count())
        return QVariant();

    if (role == Qt::DisplayRole)
    {
        return m_projectList->children[index.row()]->desc;
    }

    return QVariant();
}

void ProjectListModel::addItem(QString &str)
{
    Project* proj = new Project();
    proj->name = "project";
    proj->desc = str;

    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_projectList->children << proj;
    endInsertRows();
}

void ProjectListModel::removeItem(int i)
{
    if (i >= 0 && i < rowCount())
    {
        beginRemoveRows(QModelIndex(), i, i);
        m_projectList->children.removeAt(i);
        endRemoveRows();
    }
}

void ProjectListModel::renameItem(int i, QString &str)
{
    Project *proj = m_projectList->children[i];
    proj->desc = str;

    removeItem(i);

    beginInsertRows(QModelIndex(), i, i);
    m_projectList->children.insert(i, proj);
    endInsertRows();
}
