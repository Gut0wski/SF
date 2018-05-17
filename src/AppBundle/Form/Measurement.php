<?php

namespace AppBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\DateTimeType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Doctrine\ORM\EntityRepository;
use AppBundle\Entity\TariffsTypes;
use Symfony\Component\Form\Extension\Core\Type\MoneyType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use AppBundle\Entity\Measurements;

/**
 * Класс формы добавления нового контрольного показния
 * @package AppBundle\Form
 */
class Measurement extends AbstractType
{
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('date', DateTimeType::class, [
                'label' => 'Дата снятия',
                'date_format' => 'dd.MM.yyyy'
            ])
            ->add('type', EntityType::class, [
                'class' => TariffsTypes::class,
                'query_builder' => function (EntityRepository $er) {
                    return $er->createQueryBuilder('tt')
                        ->where('tt.calculate = 1');
                },
                'choice_label' => 'title',
                'label' => 'Ресурс',
                'attr' => ['class' => 'form-control']
            ])
            ->add('value', MoneyType::class, [
                'label' => 'Значение',
                'attr' => ['class' => 'form-control'],
                'currency' => false
            ])
            ->add('submit', SubmitType::class, [
                'attr' => [
                    'class' => 'btn btn-success pull-right'
                ],
                'label' => 'Сохранить'
            ]);
    }

    /**
     * @param OptionsResolver $resolver
     */
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Measurements::class
        ]);
    }
}