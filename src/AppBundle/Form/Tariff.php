<?php

namespace AppBundle\Form;

use AppBundle\Entity\TariffsTypes;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\MoneyType;
use AppBundle\Entity\Tariffs;

/**
 * Класс формы добавления/редактирования тарифа
 * @package AppBundle\Form
 */
class Tariff extends AbstractType
{
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('type', EntityType::class, [
                'class' => TariffsTypes::class,
                'choice_label' => 'title',
                'label' => 'Наименование ресурса',
                'attr' => ['class' => 'form-control']
            ])
            ->add('periodStart', TextType::class, [
                'label' => 'Период начала действия (например: 01.2018)',
                'attr' => ['class' => 'form-control']
            ])
            ->add('value', MoneyType::class, [
                'label' => 'Стоимость, руб.',
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
            'data_class' => Tariffs::class
        ]);
    }
}