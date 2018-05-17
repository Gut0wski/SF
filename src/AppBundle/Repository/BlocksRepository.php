<?php

namespace AppBundle\Repository;

use Doctrine\ORM\EntityRepository;

class BlocksRepository extends EntityRepository
{
    /**
     * Выборка блокировок пользователя
     * @param integer $id код пользователя
     * @return array
     */
    public function getHistoryBlocksUser($id)
    {
        $em = $this->getEntityManager();
        $statement = $em->getConnection()->prepare('call history_blocks_user(:id);');
        $statement->bindValue('id', $id);
        $statement->execute();
        return $statement->fetchAll();
    }

    /**
     * Проверка блокировки пользователя
     * @param integer $id код пользователя
     * @return array
     */
    public function getActiveBlockUser($id)
    {
        $em = $this->getEntityManager();
        $statement = $em->getConnection()->prepare('call active_block_user(:id);');
        $statement->bindValue('id', $id);
        $statement->execute();
        return $statement->fetchAll();
    }

    /**
     * Поставить оценку сообщению
     * @param integer $user код пользователя
     * @param integer $message код сообщения
     * @param integer $type тип оценки (1 - положительная, 2 - отрицательная)
     * @return array
     */
    public function getNewAssessment($user, $message, $type)
    {
        $em = $this->getEntityManager();
        $statement = $em->getConnection()->prepare('select new_assessment(:user_id, :message_id, :type_assessment);');
        $statement->bindValue('user_id', $user);
        $statement->bindValue('message_id', $message);
        $statement->bindValue('type_assessment', $type);
        $statement->execute();
        return $statement->fetchAll();
    }
}