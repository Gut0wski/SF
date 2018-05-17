<?php

namespace AppBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Ivory\CKEditorBundle\Form\Type\CKEditorType;
use AppBundle\Entity\News as NewsEntity;

/**
 * Класс формы добавления/редактирования новости
 * @package AppBundle\Form
 */
class News extends AbstractType
{
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('title', TextType::class, [
                'label' => 'Заголовок',
                'attr' => ['class' => 'form-control']
            ])
            ->add('preview', TextareaType::class, [
                'label' => 'Краткое описание',
                'attr' => ['class' => 'form-control']
            ])
            ->add('text', CKEditorType::class, [
                'label' => 'Текст',
                'attr' => ['class' => 'form-control'],
                'config' => ['uiColor' => '#F2EEDA']
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
            'data_class' => NewsEntity::class
        ]);
    }
}