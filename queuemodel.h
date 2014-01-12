#ifndef QUEUEMODEL_H
#define QUEUEMODEL_H

#include <QAbstractListModel>

class Queue;

class QueueModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit QueueModel(QObject *parent = 0);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    void setQueue(Queue* queue) { m_queue = queue; }
    Queue* getQueue() const { return m_queue; }

    void addItem(QString& str);
    void removeItem(int i);
    void renameItem(int i, QString& str);

signals:

public slots:

private:
    Queue* m_queue;
};

#endif // QUEUEMODEL_H
