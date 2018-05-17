<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Component\Security\Core\User\UserInterface;

/**
 * Класс для работы с таблицей "Пользователи"
 * @package AppBundle\Entity
 * @ORM\Table(name="users")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\UsersRepository")
 * @UniqueEntity(fields={"username", "email"}, message="Такой пользователь уже существует")
 */
class Users implements UserInterface
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $username логин
     * @ORM\Column(type="string", length=100, unique=true)
     */
    private $username;

    /**
     * @var string $password хэшированный пароль
     * @ORM\Column(type="string", length=500)
     * @Assert\Length(
     *      min = 6,
     *      minMessage = "Минимальная длина пароля не должна быть менее {{ limit }} знаков"
     * )
     */
    private $password;

    /**
     * @var string $passwordReset код сброса пароля
     * @ORM\Column(type="string", length=500, name="password_reset", nullable=true)
     */
    private $passwordReset;

    /**
     * @var string $email email
     * @ORM\Column(type="string", length=50, unique=true)
     * @Assert\Email
     */
    private $email;

    /**
     * @var string $telephone телефон
     * @ORM\Column(type="string", length=50)
     */
    private $telephone;

    /**
     * @var string $otherContacts другие контактные данные
     * @ORM\Column(type="string", length=500, name="other_contacts", nullable=true)
     */
    private $otherContacts;

    /**
     * @var string $fio Ф.И.О.
     * @ORM\Column(type="string", length=200)
     */
    private $fio;

    /**
     * @var string $sector номер участка
     * @ORM\Column(type="string", length=50)
     */
    private $sector;

    /**
     * @var string $address адрес фактического проживания (если не СТ)
     * @ORM\Column(type="string", length=500, nullable=true)
     */
    private $address;

    /**
     * @var string $dateRegister дата регистрации
     * @ORM\Column(type="datetime", name="date_register", options={"default"="CURRENT_TIMESTAMP"})
     */
    private $dateRegister;

    /**
     * @var string $dateActive дата последней активности
     * @ORM\Column(type="datetime", name="date_active", nullable=true)
     */
    private $dateActive;

    /**
     * @var string $role роль
     * @ORM\Column(type="string", length=50, nullable=true)
     */
    private $role;

    /**
     * @var string $fullRole полное наименование роли
     */
    private $fullRole;

    /**
     * Конструктор
     */
    public function __construct()
    {
        $this->dateRegister = new \DateTime();
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
     * Set username
     * @param string $username
     * @return Users
     */
    public function setUsername($username)
    {
        $this->username = $username;
        return $this;
    }

    /**
     * Get username
     * @return string
     */
    public function getUsername()
    {
        return $this->username;
    }

    /**
     * Set password
     * @param string $password
     * @return Users
     */
    public function setPassword($password)
    {
        if (!empty($password)) {
            $this->password = $password;
        }
        return $this;
    }

    /**
     * Get password
     * @return string
     */
    public function getPassword()
    {
        return $this->password;
    }

    /**
     * Set passwordReset
     * @param string $passwordReset
     * @return Users
     */
    public function setPasswordReset($passwordReset)
    {
        $this->passwordReset = $passwordReset;
        return $this;
    }

    /**
     * Get passwordReset
     * @return string
     */
    public function getPasswordReset()
    {
        return $this->passwordReset;
    }

    /**
     * Set email
     * @param string $email
     * @return Users
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
     * Set telephone
     * @param string $telephone
     * @return Users
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
     * Set otherContacts
     * @param string $otherContacts
     * @return Users
     */
    public function setOtherContacts($otherContacts)
    {
        $this->otherContacts = $otherContacts;
        return $this;
    }

    /**
     * Get otherContacts
     * @return string
     */
    public function getOtherContacts()
    {
        return $this->otherContacts;
    }

    /**
     * Set fio
     * @param string $fio
     * @return Users
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
     * Set sector
     * @param string $sector
     * @return Users
     */
    public function setSector($sector)
    {
        $this->sector = $sector;
        return $this;
    }

    /**
     * Get sector
     * @return string
     */
    public function getSector()
    {
        return $this->sector;
    }

    /**
     * Set address
     * @param string $address
     * @return Users
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
     * Set dateRegister
     * @param \DateTime $dateRegister
     * @return Users
     */
    public function setDateRegister(\DateTime $dateRegister)
    {
        $this->dateRegister = $dateRegister;
        return $this;
    }

    /**
     * Get dateRegister
     * @return \DateTime
     */
    public function getDateRegister()
    {
        return $this->dateRegister;
    }

    /**
     * Set dateActive
     * @param \DateTime $dateActive
     * @return Users
     */
    public function setDateActive(\DateTime $dateActive)
    {
        $this->dateActive = $dateActive;
        return $this;
    }

    /**
     * Get dateActive
     * @return \DateTime
     */
    public function getDateActive()
    {
        return $this->dateActive;
    }

    /**
     * Set role
     * @param string $role
     * @return Users
     */
    public function setRole($role)
    {
        $this->role = $role;
        return $this;
    }

    /**
     * Get role
     * @return string
     */
    public function getRole()
    {
        return $this->role;
    }

    /**
     * Get fullRole
     * @return string
     */
    public function getFullRole()
    {
        switch ($this->role) {
        case 'ROLE_USER':
            return 'Пользователь сайта';
        case 'ROLE_ADMIN':
            return 'Модератор обсуждений';
        case 'ROLE_SUPER_ADMIN':
            return 'Администратор';
        default:
            return 'Отсутствует';
        }
    }

    public function getRoles()
    {
        return [ (empty($this->role)) ? 'ROLE_USER' : $this->role ];
    }

    public function getSalt()
    {
        return null;
    }

    public function eraseCredentials()
    {
        // TODO: Implement eraseCredentials() method.
    }
}
