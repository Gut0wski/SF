<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * Класс для работы с таблицей "Контакты правления"
 * @package AppBundle\Entity
 * @ORM\Table(name="contacts")
 * @ORM\Entity
 */
class Contacts
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $fio Ф.И.О.
     * @ORM\Column(type="string", length=200)
     */
    private $fio;

    /**
     * @var string $telephone телефон
     * @ORM\Column(type="string", length=100)
     */
    private $telephone;

    /**
     * @var string $email email
     * @ORM\Column(type="string", length=100)
     * @Assert\Email()
     */
    private $email;

    /**
     * @var string $address адрес
     * @ORM\Column(type="string", length=300)
     */
    private $address;

    /**
     * @var string $time часы приема
     * @ORM\Column(type="string", length=300)
     */
    private $time;

    /**
     * Get id
     * @return integer
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set fio
     * @param string $fio
     * @return Contacts
     */
    public function setFio($fio)
    {
        $this->fio = $fio;
        return $this;
    }

    /**
     * Get fio
     * @return string
     */
    public function getFio()
    {
        return $this->fio;
    }

    /**
     * Set telephone
     * @param string $telephone
     * @return Contacts
     */
    public function setTelephone($telephone)
    {
        $this->telephone = $telephone;
        return $this;
    }

    /**
     * Get telephone
     * @return string
     */
    public function getTelephone()
    {
        return $this->telephone;
    }

    /**
     * Set email
     * @param string $email
     * @return Contacts
     */
    public function setEmail($email)
    {
        $this->email = $email;
        return $this;
    }

    /**
     * Get email
     * @return string
     */
    public function getEmail()
    {
        return $this->email;
    }

    /**
     * Set address
     * @param string $address
     * @return Contacts
     */
    public function setAddress($address)
    {
        $this->address = $address;
        return $this;
    }

    /**
     * Get address
     * @return string
     */
    public function getAddress()
    {
        return $this->address;
    }

    /**
     * Set time
     * @param string $time
     * @return Contacts
     */
    public function setTime($time)
    {
        $this->time = $time;
        return $this;
    }

    /**
     * Get time
     * @return string
     */
    public function getTime()
    {
        return $this->time;
    }
}
