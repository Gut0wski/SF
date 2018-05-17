<?php

namespace AppBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\DateTimeType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Doctrine\ORM\EntityRepository;
use AppBundle\Entity\TariffsTypes;
use Symfony\Component\Form\Extension\Core\Type\MoneyType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use AppBundle\Entity\Payments;

/**
 * Класс формы добавления нового платежа
 * @package AppBundle\Form
 */
class Payment extends AbstractType
{
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('date', DateTimeType::class, [
                'label' => 'Дата платежа',
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
            ->add('sum', MoneyType::class, [
                'label' => 'Сумма, руб.',
                'attr' => ['class' => 'form-control'],
                'currency' => false
            ])
            ->add('place', TextType::class, [
                'label' => 'Место оплаты',
                'attr' => ['class' => 'form-control'],
                'required' => false
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
            'data_class' => Payments::class
        ]);
    }
}