<?php

namespace AppBundle\Extend\Utils;

class Paginate
{
    /**
     * Поиск страницы при изменении записи
     * @param integer $id код записи
     * @param array $array массив объекта БД
     * @param integer $limit количество записей на страницу
     * @return integer
     */
    public static function findPageModify($id, $array, $limit)
    {
        foreach ($array as $key => $i) {
            if ($i->getId() == $id) {
                return ceil(($key + 1) / $limit);
            }
        }
    }
    public static function findPageModify2($id, $array, $limit)
    {
        foreach ($array as $key => $i) {
            if ($i['id'] == $id) {
                return ceil(($key + 1) / $limit);
            }
        }
    }

    /**
     * Поиск страницы при удалении записи
     * @param array $array массив объекта БД
     * @param integer $limit количество записей на страницу
     * @return integer
     */
    public static function findPageDelete($array, $limit)
    {
        foreach ($array as $key => $i) {
            if ($i->getId() == null) {
                if ($key == 0) {
                    return 1;
                } else {
                    $prev_id = $array[$key - 1]->getId();
                }
            }
        }
        foreach ($array as $key => $i) {
            if ($i->getId() == $prev_id) {
                return ceil(($key + 1) / $limit);
            }
        }
    }
    public static function findPageDelete2($id, $array, $limit)
    {
        foreach ($array as $key => $i) {
            if ($i['id'] == $id) {
                if ($key == 0) {
                    return 1;
                } else {
                    $prev_id = $array[$key - 1]['id'];
                }
            }
        }
        foreach ($array as $key => $i) {
            if ($i['id'] == $prev_id) {
                return ceil(($key + 1) / $limit);
            }
        }
    }
}