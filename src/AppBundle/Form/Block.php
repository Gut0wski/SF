<?php

namespace AppBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\DateTimeType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use AppBundle\Entity\Blocks;

/**
 * Класс формы блокировки
 * @package AppBundle\Form
 */
class Block extends AbstractType
{
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('dateStart', DateTimeType::class, [
                'label' => 'Дата начала',
                'date_format' => 'dd.MM.yyyy'
            ])
            ->add('dateEnd', DateTimeType::class, [
                'label' => 'Дата окончания',
                'date_format' => 'dd.MM.yyyy'
            ])
            ->add('reason', TextareaType::class, [
                'label' => 'Описание причины',
                'attr' => ['class' => 'form-control']
            ])
            ->add('submit', SubmitType::class, [
                'attr' => [
                    'class' => 'btn btn-success pull-right'
                ],
                'label' => 'Сохранить изменения'
            ]);
    }

    /**
     * @param OptionsResolver $resolver
     */
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Blocks::class
        ]);
    }
}