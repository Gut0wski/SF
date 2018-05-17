<?php

namespace AppBundle\Twig;

class AppExtension extends \Twig_Extension
{
    public function getFunctions()
    {
        return array(
            new \Twig_SimpleFunction('new_rowspan', [$this, 'calculateRowspan']),
            new \Twig_SimpleFunction('calc_credit', [$this, 'calculateCredit']),
        );
    }

    public function calculateRowspan($names, $from, $column)
    {
        if ($from > 0 && $names[$from - 1][$column] === $names[$from][$column]) {
            return;
        }
        for ($to = $from + 1; isset($names[$to]) && $names[$to][$column] === $names[$from][$column]; $to++);
        return $to - $from;
    }

    public function calculateCredit($rows, $num, $type)
    {
        $items = array_reverse($rows);
        $credit = 0;
        foreach ($items as $item) {
            if (($item['num'] >= $num) && ($item['type'] == $type)) {
                $credit += $item['to_pay'] - $item['payment'];
            }
        }
        return $credit;
    }
}