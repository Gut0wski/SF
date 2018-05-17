<?php

namespace AppBundle\Repository;

use Doctrine\ORM\EntityRepository;

class DiscussionsRepository extends EntityRepository
{
    /**
     * Сообщения темы с вложженостью
     * @param integer $id код темы
     * @return array
     */
    public function getSubjectMessages($id)
    {
        $em = $this->getEntityManager();
        $statement = $em->getConnection()->prepare('call subject_messages(:id);');
        $statement->bindValue('id', $id);
        $statement->execute();
        return $statement->fetchAll();
    }
}