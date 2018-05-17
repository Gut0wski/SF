<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use AppBundle\Entity\Users;

/**
 * Класс для работы с таблицей "Блокировки пользователей"
 * @package AppBundle\Entity
 * @ORM\Table(name="blocks")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\BlocksRepository")
 */
class Blocks
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $dateStart дата начала блокировки
     * @ORM\Column(type="datetime", name="date_start")
     */
    private $dateStart;

    /**
     * @var string $dateEnd дата окончания блокировки
     * @ORM\Column(type="datetime", name="date_end")
     */
    private $dateEnd;

    /**
     * @var integer $user заблокированный пользователь
     * @ORM\ManyToOne(targetEntity="Users")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="user", referencedColumnName="id")
     * })
     */
    private $user;

    /**
     * @var integer $moderator кем блокирован
     * @ORM\ManyToOne(targetEntity="Users")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="moderator", referencedColumnName="id")
     * })
     */
    private $moderator;

    /**
     * @var string $reason причина блокировки
     * @ORM\Column(type="string", length=500)
     */
    private $reason;

    /**
     * Конструктор
     */
    public function __construct()
    {
        $this->dateStart = new \DateTime();
        $this->dateEnd = new \DateTime();
        $this->user = new ArrayCollection();
        $this->moderator = new ArrayCollection();
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
     * Set dateStart
     * @param \DateTime $dateStart
     * @return Blocks
     */
    public function setDateStart(\DateTime $dateStart)
    {
        $this->dateStart = $dateStart;
        return $this;
    }

    /**
     * Get dateStart
     * @return \DateTime
     */
    public function getDateStart()
    {
        return $this->dateStart;
    }

    /**
     * Set dateEnd
     * @param \DateTime $dateEnd
     * @return Blocks
     */
    public function setDateEnd(\DateTime $dateEnd)
    {
        $this->dateEnd = $dateEnd;
        return $this;
    }

    /**
     * Get dateEnd
     * @return \DateTime
     */
    public function getDateEnd()
    {
        return $this->dateEnd;
    }

    /**
     * Set user
     * @param Users $user
     * @return Blocks
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
     * Set moderator
     * @param Users $moderator
     * @return Blocks
     */
    public function setModerator(Users $moderator)
    {
        $this->moderator = $moderator;
        return $this;
    }

    /**
     * Get moderator
     * @return Users
     */
    public function getModerator()
    {
        return $this->moderator;
    }

    /**
     * Set reason
     * @param string $reason
     * @return Blocks
     */
    public function setReason($reason)
    {
        $this->reason = $reason;
        return $this;
    }

    /**
     * Get reason
     * @return string
     */
    public function getReason()
    {
        return $this->reason;
    }
}
