<?php

namespace AppBundle\Entity;

use AppBundle\Extend\Utils\FileInfo;
use Doctrine\ORM\Mapping as ORM;

/**
 * Класс для работы с таблицей "Документы"
 * @package AppBundle\Entity
 * @ORM\Table(name="documents")
 * @ORM\Entity
 */
class Documents
{
    /**
     * @var integer $id
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string $date дата добавления
     * @ORM\Column(type="datetime", options={"default"="CURRENT_TIMESTAMP"})
     */
    private $date;

    /**
     * @var string $description описание
     * @ORM\Column(type="string", length=500)
     */
    private $description;

    /**
     * @var string $file имя файла
     * @ORM\Column(type="string", length=300)
     */
    private $file;

    /**
     * @var string $sizeFile размер файла
     */
    private $sizeFile;

    /**
     * @var string $imgFile изображение расширения файла
     */
    private $imgFile;

    /**
     * Конструктор
     */
    public function __construct()
    {
        $this->date = new \DateTime();
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
     * @return Documents
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
     * Set description
     * @param string $description
     * @return Documents
     */
    public function setDescription($description)
    {
        $this->description = $description;
        return $this;
    }

    /**
     * Get description
     * @return string
     */
    public function getDescription()
    {
        return $this->description;
    }

    /**
     * Set file
     * @param string $file
     * @return Documents
     */
    public function setFile($file)
    {
        $this->file = $file;
        return $this;
    }

    /**
     * Get file
     * @return string
     */
    public function getFile()
    {
        return $this->file;
    }

    /**
     * Get sizeFile
     * @return string
     */
    public function getSizeFile()
    {
        return FileInfo::getSize($this->file);
    }

    /**
     * Get ImgFile
     * @return string
     */
    public function getImgFile()
    {
        return FileInfo::getImg($this->file);
    }
}
