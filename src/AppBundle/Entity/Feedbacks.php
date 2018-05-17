<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use AppBundle\Entity\Users;

/**
 * Класс для работы с таблицей "Отклики на обсуждения"
 * @package AppBundle\Entity
 * @ORM\Table(name="feedbacks")
 * @ORM\Entity
 */
class Feedbacks
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $date дата создания
     * @ORM\Column(type="datetime", options={"default"="CURRENT_TIMESTAMP"})
     */
    private $date;

    /**
     * @var integer $message сообщение
     * @ORM\ManyToOne(targetEntity="Discussions")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="message", referencedColumnName="id")
     * })
     */
    private $message;

    /**
     * @var integer $type тип отклика (1 - жалоба, 2 - лайк, 3 - дизлайк)
     * @ORM\Column(type="smallint")
     */
    private $type;

    /**
     * @var integer $user откликнувшийся
     * @ORM\ManyToOne(targetEntity="Users")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="user", referencedColumnName="id")
     * })
     */
    private $user;

    /**
     * @var string $text причина жалобы (при типе = 1)
     * @ORM\Column(type="string", length=500, nullable=true)
     */
    private $text;

    /**
     * Конструктор
     */
    public function __construct()
    {
        $this->date = new \DateTime();
        $this->message = new ArrayCollection();
        $this->user = new ArrayCollection();
    }

    /**
     * Get id
     * @return integer
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set date
     * @param \DateTime $date
     * @return Feedbacks
     */
    public function setDate(\DateTime $date)
    {
        $this->date = $date;
        return $this;
    }

    /**
     * Get date
     * @return \DateTime
     */
    public function getDate()
    {
        return $this->date;
    }

    /**
     * Set message
     * @param Discussions $message
     * @return Feedbacks
     */
    public function setMessage(Discussions $message)
    {
        $this->message = $message;
        return $this;
    }

    /**
     * Get message
     * @return Discussions
     */
    public function getMessage()
    {
        return $this->message;
    }

    /**
     * Set type
     * @param integer $type
     * @return Feedbacks
     */
    public function setType($type)
    {
        $this->type = $type;
        return $this;
    }

    /**
     * Get type
     * @return integer
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * Set user
     * @param Users $user
     * @return Feedbacks
     */
    public function setUser(Users $user)
    {
        $this->user = $user;
        return $this;
    }

    /**
     * Get user
     * @return Users
     */
    public function getUser()
    {
        return $this->user;
    }

    /**
     * Set text
     * @param string $text
     * @return Feedbacks
     */
    public function setText($text)
    {
        $this->text = $text;
        return $this;
    }

    /**
     * Get text
     * @return string
     */
    public function getText()
    {
        return $this->text;
    }
}
