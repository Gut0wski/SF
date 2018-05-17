<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use AppBundle\Entity\Users;

/**
 * Класс для работы с таблицей "Сообщения между пользователями"
 * @package AppBundle\Entity
 * @ORM\Table(name="messages")
 * @ORM\Entity
 */
class Messages
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $date дата отправки
     * @ORM\Column(type="datetime", options={"default"="CURRENT_TIMESTAMP"})
     */
    private $date;

    /**
     * @var integer $recipient получатель
     * @ORM\ManyToOne(targetEntity="Users")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="recipient", referencedColumnName="id")
     * })
     */
    private $recipient;

    /**
     * @var integer $sender отправитель
     * @ORM\ManyToOne(targetEntity="Users")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="sender", referencedColumnName="id")
     * })
     */
    private $sender;

    /**
     * @var string $subject тема сообщения
     * @ORM\Column(type="string", length=200)
     */
    private $subject;

    /**
     * @var string $text текст сообщения
     * @ORM\Column(type="text")
     */
    private $text;

    /**
     * @var boolean $reading сообщение прочитано (0 - нет, 1 - да)
     * @ORM\Column(type="boolean", options={"default" : 0})
     */
    private $reading;

    /**
     * Конструктор
     */
    public function __construct()
    {
        $this->date = new \DateTime();
        $this->reading = 0;
        $this->recipient = new ArrayCollection();
        $this->sender = new ArrayCollection();
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
     * @return Messages
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
     * Set recipient
     * @param Users $recipient
     * @return Messages
     */
    public function setRecipient(Users $recipient)
    {
        $this->recipient = $recipient;
        return $this;
    }

    /**
     * Get recipient
     * @return Users
     */
    public function getRecipient()
    {
        return $this->recipient;
    }

    /**
     * Set sender
     * @param Users $sender
     * @return Messages
     */
    public function setSender(Users $sender)
    {
        $this->sender = $sender;
        return $this;
    }

    /**
     * Get sender
     * @return Users
     */
    public function getSender()
    {
        return $this->sender;
    }

    /**
     * Set subject
     * @param string $subject
     * @return Messages
     */
    public function setSubject($subject)
    {
        $this->subject = $subject;
        return $this;
    }

    /**
     * Get subject
     * @return string
     */
    public function getSubject()
    {
        return $this->subject;
    }

    /**
     * Set text
     * @param string $text
     * @return Messages
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

    /**
     * Set reading
     * @param boolean $reading
     * @return Messages
     */
    public function setReading($reading)
    {
        $this->reading = $reading;
        return $this;
    }

    /**
     * Get reading
     * @return boolean
     */
    public function getReading()
    {
        return $this->reading;
    }
}
