<?php

namespace AppBundle\Extend\Utils;

use Symfony\Component\Finder\Finder;

/**
 * Получение информации о файле
 */
class FileInfo
{
    const DIR = __DIR__ .
        DIRECTORY_SEPARATOR . '..' .
        DIRECTORY_SEPARATOR . '..' .
        DIRECTORY_SEPARATOR . '..' .
        DIRECTORY_SEPARATOR . '..' .
        DIRECTORY_SEPARATOR . 'web' .
        DIRECTORY_SEPARATOR;

    /**
     * Вычисление размера файла
     * @param string $filename имя файла
     * @return string
     */
    public static function getSize($filename)
    {
        $finder = new Finder();
        $finder->files()->in(self::DIR . 'files' . DIRECTORY_SEPARATOR);
        $finder->name($filename);
        foreach ($finder as $file) {
            $fileSize = $file->getSize();
        }
        $a = array("Б", "Кб", "Мб", "Гб", "Тб");
        $pos = 0;
        while ($fileSize >= 1024) {
            $fileSize /= 1024;
            $pos++;
        }
        return round($fileSize,2)." ".$a[$pos];
    }

    /**
     * Получение картинки расширения файла
     * @param string $filename имя файла
     * @return string
     */
    public static function getImg($filename)
    {
        $finder = new Finder();
        $finder->files()->in(self::DIR . 'files' . DIRECTORY_SEPARATOR);
        $finder->name($filename);
        foreach ($finder as $file) {
            $fileExtension = $file->getExtension();
        }
        switch ($fileExtension) {
            case 'txt':
                $img = 'txt.png';
                break;
            case 'doc':
            case 'docx':
                $img = 'doc.png';
                break;
            case 'jpg':
            case 'jpeg':
            case 'png':
            case 'bmp':
                $img = 'img.png';
                break;
            case 'zip':
            case 'rar':
                $img = 'zip.png';
                break;
            case 'pdf':
                $img = 'pdf.png';
                break;
            case 'csv':
            case 'xls':
            case 'xlsx':
                $img = 'xls.png';
                break;
            default:
                $img = 'none.png';
        }
        return $img;
    }
}