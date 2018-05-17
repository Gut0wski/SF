<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

/**
 * Класс для работы с таблицей "Обсуждения"
 * @package AppBundle\Entity
 * @ORM\Table(name="discussions")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\DiscussionsRepository")
 */
class Discussions
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $dateCreate дата создания
     * @ORM\Column(type="datetime", name="date_create", options={"default"="CURRENT_TIMESTAMP"})
     */
    private $dateCreate;

    /**
     * @var string $dateUpdate дата редактирования
     * @ORM\Column(type="datetime", name="date_update", nullable=true)
     */
    private $dateUpdate;

    /**
     * @var integer $type тип (1 - раздел, 2 - тема, 3 - сообщение)
     * @ORM\Column(type="smallint")
     */
    private $type;

    /**
     * @var integer $parent код родителя
     * @ORM\ManyToOne(targetEntity="Discussions")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="parent", referencedColumnName="id")
     * })
     */
    private $parent;

    /**
     * @var integer $user автор
     * @ORM\Column(type="integer")
     * @ORM\ManyToOne(targetEntity="Users")
     * @ORM\JoinColumn(name="user", referencedColumnName="id")
     */
    private $user;

    /**
     * @var string $title заголовок
     * @ORM\Column(type="string", length=300)
     */
    private $title;

    /**
     * @var string $text текст
     * @ORM\Column(type="text")
     */
    private $text;

    /**
     * @var boolean $hidden скрыто для незарегистрированных пользователей (0 - нет, 1 - да)
     * @ORM\Column(type="boolean", options={"default" : 0})
     */
    private $hidden;

    /**
     * Конструктор
     */
    public function __construct()
    {
        $this->dateCreate = new \DateTime();
        $this->parent = new ArrayCollection();
        $this->hidden = 0;
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
     * Set dateCreate
     * @param \DateTime $dateCreate
     * @return Discussions
     */
    public function setDateCreate(\DateTime $dateCreate)
    {
        $this->dateCreate = $dateCreate;
        return $this;
    }

    /**
     * Get dateCreate
     * @return \DateTime
     */
    public function getDateCreate()
    {
        return $this->dateCreate;
    }

    /**
     * Set dateUpdate
     * @param \DateTime $dateUpdate
     * @return Discussions
     */
    public function setDateUpdate(\DateTime $dateUpdate)
    {
        $this->dateUpdate = $dateUpdate;
        return $this;
    }

    /**
     * Get dateUpdate
     * @return \DateTime
     */
    public function getDateUpdate()
    {
        return $this->dateUpdate;
    }

    /**
     * Set type
     * @param integer $type
     * @return Discussions
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
     * Set parent
     * @param null|Discussions $parent
     * @return Discussions
     */
    public function setParent($parent)
    {
        $this->parent = $parent;
        return $this;
    }

    /**
     * Get parent
     * @return Discussions
     */
    public function getParent()
    {
        return $this->parent;
    }

    /**
     * Set user
     * @param integer $user
     * @return Discussions
     */
    public function setUser($user)
    {
        $this->user = $user;
        return $this;
    }

    /**
     * Get user
     * @return integer
     */
    public function getUser()
    {
        return $this->user;
    }

    /**
     * Set title
     * @param string $title
     * @return Discussions
     */
    public function setTitle($title)
    {
        $this->title = $title;
        return $this;
    }

    /**
     * Get title
     * @return string
     */
    public function getTitle()
    {
        return $this->title;
    }

    /**
     * Set text
     * @param string $text
     * @return Discussions
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
     * Set hidden
     * @param boolean $hidden
     * @return Discussions
     */
    public function setHidden($hidden)
    {
        $this->hidden = $hidden;
        return $this;
    }

    /**
     * Get hidden
     * @return boolean
     */
    public function getHidden()
    {
        return ($this->hidden == 1) ? true : false;
    }
}
